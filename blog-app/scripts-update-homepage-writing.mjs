import fs from 'node:fs';
import path from 'node:path';
import matter from 'gray-matter';

const rootDir = path.resolve(process.argv[2] || '.');
const blogDir = path.join(rootDir, 'blog-app', 'src', 'pages', 'blog');
const indexPath = path.join(rootDir, 'index.html');

const posts = fs.readdirSync(blogDir)
  .filter((file) => file.endsWith('.md') && !file.endsWith('.zh.md'))
  .map((file) => {
    const fullPath = path.join(blogDir, file);
    const raw = fs.readFileSync(fullPath, 'utf8');
    const { data } = matter(raw);
    const slug = file.replace(/\.md$/, '');
    const pubDate = data.pubDate ? new Date(data.pubDate) : null;
    return {
      slug,
      title: data.title ?? slug,
      description: data.description ?? '',
      tags: Array.isArray(data.tags) ? data.tags : [],
      pubDate,
    };
  })
  .sort((a, b) => (b.pubDate?.getTime() ?? 0) - (a.pubDate?.getTime() ?? 0));

const cards = posts.length > 0
  ? posts.slice(0, 3).map((post) => {
      const dateText = post.pubDate
        ? post.pubDate.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' })
        : '';
      const meta = [dateText, 'Blog', ...post.tags].filter(Boolean).join(' · ');
      return [
        '          <div class="writing-item">',
        `            <h4><a href="blog/${post.slug}/">${post.title}</a></h4>`,
        `            <p class="meta">${meta}</p>`,
        `            <p>${post.description}</p>`,
        '          </div>'
      ].join('\n');
    }).join('\n')
  : [
      '          <div class="writing-item">',
      '            <h4>A writing space in progress</h4>',
      '            <p class="meta">Blog</p>',
      '            <p>This section is reserved for future essays, technical notes, and project reflections on AI, machine learning, and engineering. New writing will appear here over time.</p>',
      '          </div>'
    ].join('\n');

const replacement = [
  '        <div class="section-block">',
  '          <h2 id="writing">Writing</h2>',
  '          <p class="section-lead">Technical notes, project reflections, and research-related writing.</p>',
  cards,
  '          <p><a href="blog/">Visit the writing page →</a></p>',
  '        </div>'
].join('\n');

const html = fs.readFileSync(indexPath, 'utf8');
const pattern = /        <div class="section-block">\n          <h2 id="writing">Writing<\/h2>[\s\S]*?          <p><a href="blog\/">Visit the writing page →<\/a><\/p>\n        <\/div>/;

if (!pattern.test(html)) {
  throw new Error('Could not locate homepage writing section to update.');
}

const updated = html.replace(pattern, replacement);
fs.writeFileSync(indexPath, updated);
console.log('Updated homepage writing section in index.html');
