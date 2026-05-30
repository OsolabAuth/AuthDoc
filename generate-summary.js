#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const docsRootArg = process.argv[2];
const docsRoot = path.resolve(docsRootArg || __dirname);
const summaryPath = path.join(docsRoot, "SUMMARY.md");
const excludeDirs = new Set(["node_modules", "_book", ".git"]);

function getLinkLabel(filePath) {
  const defaultLabel = path.basename(filePath, path.extname(filePath));

  try {
    const content = fs.readFileSync(filePath, "utf8");
    const firstLine = content.split(/\r?\n/, 1)[0];
    if (!firstLine) {
      return defaultLabel;
    }

    const trimmed = firstLine.trim();
    const match = trimmed.match(/^#+\s*(.+)$/);
    return match ? match[1].trim() : defaultLabel;
  } catch {
    return defaultLabel;
  }
}

function collectMarkdownFiles(dirPath, result = []) {
  const entries = fs.readdirSync(dirPath, { withFileTypes: true });

  for (const entry of entries) {
    if (excludeDirs.has(entry.name)) {
      continue;
    }

    const fullPath = path.join(dirPath, entry.name);
    if (entry.isDirectory()) {
      collectMarkdownFiles(fullPath, result);
      continue;
    }

    if (!entry.isFile() || path.extname(entry.name).toLowerCase() !== ".md") {
      continue;
    }

    if (entry.name === "SUMMARY.md") {
      continue;
    }

    result.push(fullPath);
  }

  return result;
}

const mdFiles = collectMarkdownFiles(docsRoot).sort((a, b) => a.localeCompare(b));
const rootFiles = [];
const grouped = new Map();

for (const filePath of mdFiles) {
  const relativePath = path.relative(docsRoot, filePath).split(path.sep).join("/");
  const parts = relativePath.split("/");
  const label = getLinkLabel(filePath);
  const item = { label, path: relativePath };

  if (parts.length === 1) {
    rootFiles.push(item);
    continue;
  }

  const section = parts[0];
  if (!grouped.has(section)) {
    grouped.set(section, []);
  }

  grouped.get(section).push(item);
}

const lines = ["# Summary", ""];

for (const item of rootFiles) {
  lines.push(`* [${item.label}](${item.path})`);
}

if (rootFiles.length > 0 && grouped.size > 0) {
  lines.push("");
}

for (const [section, items] of grouped.entries()) {
  lines.push(`## ${section}`);
  for (const item of items) {
    lines.push(`* [${item.label}](${item.path})`);
  }
  lines.push("");
}

while (lines.length > 0 && lines[lines.length - 1] === "") {
  lines.pop();
}

fs.writeFileSync(summaryPath, `${lines.join("\n")}\n`, "utf8");
console.log(`Updated: ${summaryPath}`);
