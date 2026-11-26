/**
 * main.ts — validate entry.png and copy it to the make.fun output directory.
 *
 * Checks:
 *   - PNG signature is exact (89 50 4E 47 0D 0A 1A 0A)
 *   - IHDR width and height are both <= 1024
 *   - file size <= 1,048,576 bytes
 *
 * Run:  node main.ts
 * Output dir: process.env.MAKEFUN_OUTPUT_DIR ?? "/output"
 */
import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';

const PNG_SIGNATURE = Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);
const MAX_SIDE = 1024;
const MAX_BYTES = 1048576;

const source = path.resolve(process.argv[2] ?? 'entry.png');
const outDir = path.resolve(process.env.MAKEFUN_OUTPUT_DIR ?? '/output');
const target = path.join(outDir, 'entry.png');

function fail(message: string): never {
  console.error(`main.ts: ${message}`);
  process.exit(1);
}

if (!fs.existsSync(source)) fail(`missing file: ${source}`);

const bytes = fs.readFileSync(source);
if (bytes.length > MAX_BYTES) {
  fail(`file is ${bytes.length} bytes, over the ${MAX_BYTES}-byte limit`);
}
if (bytes.length < 24) fail(`file is too short to be a PNG (${bytes.length} bytes)`);
if (!bytes.subarray(0, 8).equals(PNG_SIGNATURE)) fail('not a PNG (bad signature)');
if (bytes.toString('ascii', 12, 16) !== 'IHDR') fail('missing IHDR chunk');

const width = bytes.readUInt32BE(16);
const height = bytes.readUInt32BE(20);
if (width > MAX_SIDE || height > MAX_SIDE) {
  fail(`image is ${width}x${height}, over ${MAX_SIDE}x${MAX_SIDE}`);
}

fs.mkdirSync(outDir, { recursive: true });
fs.copyFileSync(source, target);

console.log(`entry.png OK: ${width}x${height}, ${bytes.length} bytes`);
console.log(`copied to ${target}`);
