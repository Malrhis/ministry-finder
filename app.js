// ── SUPABASE CONFIG ──────────────────────────────────────────────────────────
const SUPABASE_URL  = 'https://ywhyrbsycmifelqoepah.supabase.co';
const SUPABASE_ANON = 'sb_publishable_lrTA6ripi8etEVVGx39LfA_lVPOVCz9';
const db = supabase.createClient(SUPABASE_URL, SUPABASE_ANON);
// ────────────────────────────────────────────────────────────────────────────

let DATA = [];
let currentSessionId = null;

const ministriesPromise = loadMinistriesFromDB();

async function loadMinistriesFromDB() {
  try {
    const { data, error } = await db
      .from('ministries')
      .select('name, description, phone, email, meeting, age, app_categories, who_adult, who_youth')
      .eq('active', true)
      .eq('rcia_suitable', true)
      .order('sort_order');
    if (error) throw error;
    DATA = data || [];
  } catch {
    console.warn('Could not load ministries.');
    DATA = [];
  }
}

// ── RESULTS ──────────────────────────────────────────────────────────────────
const CAT_LABELS = {
  pray:      '🙏 Pray',
  learn:     '📖 Learn',
  mission:   '🤲 Mission',
  sacrament: '✝️ Sacraments'
};

function buildBadges(cats) {
  if (!cats || !cats.length) return '';
  return '<div class="badges">' +
    cats.map(c => {
      const safeCls = c.replace(/[^a-z0-9-]/gi, '');
      return `<span class="badge badge-${safeCls}">${esc(CAT_LABELS[c] || c)}</span>`;
    }).join('') +
    '</div>';
}

function getResults(data, q1, q2) {
  const isAdult  = q2.includes('adult');
  const isYouth  = q2.includes('youth');
  const isRandom = q1.includes('random');

  let filtered = data.filter(m => {
    if (isAdult && isYouth) return m.who_adult || m.who_youth;
    if (isAdult) return m.who_adult;
    if (isYouth) return m.who_youth;
    return true;
  });

  if (isRandom) {
    return filtered.sort(() => Math.random() - 0.5).slice(0, 10);
  }

  return filtered
    .map(m => {
      const cats = m.app_categories || [];
      const matches = q1.filter(c => cats.includes(c)).length;
      return { m, matches };
    })
    .filter(x => x.matches > 0)
    .sort((a, b) => b.matches - a.matches)
    .map(x => x.m);
}

// ── CTA TRACKING ─────────────────────────────────────────────────────────────
const _ctaRegistry = {};

function _cta(key, type) {
  const e = _ctaRegistry[key];
  if (e) trackCta(e.sessionId, e.name, type);
}

async function trackCta(sessionId, ministryName, ctaType) {
  if (!sessionId) return;
  try {
    await db.from('cta_events').insert({
      session_id:    sessionId,
      ministry_name: ministryName,
      cta_type:      ctaType
    });
  } catch {
    console.warn('Could not track CTA.');
  }
}

// ── CARD BUILDER ─────────────────────────────────────────────────────────────
function esc(s) {
  return String(s ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function cleanPhone(p) {
  if (!p) return null;
  const first = p.split('/')[0].trim();
  const d = first.replace(/\D/g, '');
  if (d.length < 8) return null;
  const last8 = d.slice(-8);
  if (last8.startsWith('6')) return null;
  return '65' + last8;
}

function safeUrl(raw) {
  const s = raw.split('|')[0].trim();
  if (s.startsWith('https://')) return s;
  if (s.startsWith('http://'))  return 'https://' + s.slice(7);
  return 'https://' + s;
}

function isUrl(s) {
  return s && (s.startsWith('http') || s.startsWith('www') || s.startsWith('bit.'));
}

function buildCard(m, sessionId) {
  const msg = encodeURIComponent(
    `Hi! I'm a new parishioner at St Ignatius. I'd love to learn more about ${m.name}. Could you tell me how I can get involved?`
  );
  const ph  = cleanPhone(m.phone);
  const key = 'k' + Math.random().toString(36).slice(2);
  _ctaRegistry[key] = { sessionId, name: m.name };

  let btn = '';
  if (ph) {
    btn = `<a class="cbtn wa" href="https://wa.me/${ph}?text=${msg}"
      target="_blank" rel="noopener noreferrer"
      data-cta-key="${key}" data-cta-type="whatsapp">💬 WhatsApp</a>`;
  } else if (m.email && isUrl(m.email)) {
    const url = safeUrl(m.email);
    btn = `<a class="cbtn wb" href="${esc(url)}"
      target="_blank" rel="noopener noreferrer"
      data-cta-key="${key}" data-cta-type="website">🔗 Learn More</a>`;
  } else {
    btn = `<a class="cbtn em" href="mailto:church@stignatius.org.sg?subject=Enquiry about ${encodeURIComponent(m.name)}&body=${msg}"
      data-cta-key="${key}" data-cta-type="parish_office">✉️ Contact Parish Office</a>`;
  }

  const meta = [
    m.meeting ? `🕐 ${esc(m.meeting)}` : '',
    m.age     ? `👤 ${esc(m.age)}`     : ''
  ].filter(Boolean).join('<br>');

  return `<div class="card">
    <div class="card-name">${esc(m.name)}</div>
    ${buildBadges(m.app_categories)}
    <div class="card-desc">${esc(m.description || 'A ministry at Church of St Ignatius — contact us to find out more!')}</div>
    ${meta ? `<div class="card-meta">${meta}</div>` : ''}
    ${btn}
  </div>`;
}

// ── SAVE SESSION ─────────────────────────────────────────────────────────────
async function saveSession(name, growInterests, ageGroup, topMinistries) {
  try {
    const sessionId = crypto.randomUUID();
    const { error } = await db
      .from('sessions')
      .insert({
        id:                     sessionId,
        name,
        grow_interests:         growInterests,
        age_group:              ageGroup,
        recommended_ministries: topMinistries,
        pdpa_consent:           true
      });
    if (error) throw error;
    return sessionId;
  } catch {
    console.warn('Could not save session.');
    return null;
  }
}

// ── FLOW ─────────────────────────────────────────────────────────────────────
let q1 = [], q2 = [];

function go(to) {
  if (to === 's2') { q1 = getVals('s1'); if (!q1.length) return; }
  document.querySelectorAll('.screen').forEach(s => s.classList.remove('active'));
  document.getElementById(to).classList.add('active');
  window.scrollTo(0, 0);
}

function tog(el, sid) {
  const isRandom    = el.dataset.v === 'random';
  const wasSelected = el.classList.contains('sel');

  if (isRandom && !wasSelected) {
    document.querySelectorAll(`#${sid} .opt`).forEach(o => o.classList.remove('sel'));
  } else if (!isRandom && !wasSelected) {
    const randomOpt = document.querySelector(`#${sid} .opt[data-v="random"]`);
    if (randomOpt) randomOpt.classList.remove('sel');
  }

  el.classList.toggle('sel');
  const n   = document.querySelectorAll(`#${sid} .opt.sel`).length;
  const btn = document.getElementById(sid.replace('s', 'b'));
  if (btn) btn.disabled = n === 0;
}

function getVals(sid) {
  return [...document.querySelectorAll(`#${sid} .opt.sel`)].map(o => o.dataset.v);
}

async function showRes() {
  q2 = getVals('s2');
  if (!q2.length) return;

  const name     = document.getElementById('uname').value.trim();
  const isRandom = q1.includes('random');

  go('s4');
  const rc = document.getElementById('rcards');
  rc.innerHTML = '<div class="loading"><div class="spinner"></div>Finding your ministries…</div>';

  await ministriesPromise;

  const results = getResults(DATA, q1, q2);
  const count   = results.length;

  const sessionId = await saveSession(name, q1, q2, results.slice(0, 20).map(m => m.name));
  currentSessionId = sessionId;

  const rsub = document.getElementById('rsub');
  if (isRandom) {
    rsub.textContent = name
      ? `Let the Spirit guide you, ${name}! Here are 10 ministries that need you.`
      : `Let the Spirit guide you! Here are 10 ministries that need you.`;
  } else {
    rsub.textContent = name
      ? `Here are ${count} ${count === 1 ? 'ministry' : 'ministries'} that match your interests, ${name}!`
      : `Here are ${count} ${count === 1 ? 'ministry' : 'ministries'} that match your interests.`;
  }

  rc.innerHTML = count
    ? results.map(m => buildCard(m, sessionId)).join('')
    : '<p style="text-align:center;color:#9aa3be;padding:30px 0">No matches found — try different answers!</p>';
}

function checkStart() {
  const name    = document.getElementById('uname').value.trim();
  const consent = document.getElementById('uconsent').checked;
  document.getElementById('bstart').disabled = !(name && consent);
}

function restart() {
  q1 = []; q2 = [];
  currentSessionId = null;
  document.querySelectorAll('.opt').forEach(o => o.classList.remove('sel'));
  ['b1', 'b2'].forEach(id => { const b = document.getElementById(id); if (b) b.disabled = true; });
  document.getElementById('uconsent').checked = false;
  document.getElementById('bstart').disabled  = true;
  go('s0');
}

// ── EVENT LISTENERS ──────────────────────────────────────────────────────────
document.getElementById('uname').addEventListener('input', checkStart);
document.getElementById('uconsent').addEventListener('change', checkStart);
document.getElementById('bstart').addEventListener('click', () => go('s1'));
document.getElementById('b1').addEventListener('click', () => go('s2'));
document.getElementById('b2').addEventListener('click', showRes);
document.getElementById('btryagain').addEventListener('click', restart);

document.getElementById('o1').addEventListener('click', e => {
  const opt = e.target.closest('.opt');
  if (opt) tog(opt, 's1');
});

document.getElementById('o2').addEventListener('click', e => {
  const opt = e.target.closest('.opt');
  if (opt) tog(opt, 's2');
});

// Delegated listener for CTA buttons in dynamically built cards
document.getElementById('rcards').addEventListener('click', e => {
  const btn = e.target.closest('[data-cta-key]');
  if (btn) _cta(btn.dataset.ctaKey, btn.dataset.ctaType);
});
