// Validate the delivered PNG against the competition gate, then copy it to the output directory.
// Node 22 standard library only.
//   mkdir -p out && MAKEFUN_OUTPUT_DIR=out node main.ts
import { readFileSync, writeFileSync, mkdirSync, copyFileSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const source = join(here, 'entry.png');
const outDir = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';
const target = join(outDir, 'entry.png');

const bytes = readFileSync(source);
const SIG = Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);
if (bytes.length < 24) throw new Error('entry.png is too short to be a PNG');
if (!bytes.subarray(0, 8).equals(SIG)) throw new Error('entry.png is not a PNG');
if (bytes.toString('ascii', 12, 16) !== 'IHDR') throw new Error('entry.png has no IHDR chunk');
const width = bytes.readUInt32BE(16);
const height = bytes.readUInt32BE(20);
if (width < 1 || height < 1 || width > 1024 || height > 1024) {
  throw new Error(`entry.png is ${width}x${height}; the gate allows at most 1024x1024`);
}
if (bytes.length > 1048576) throw new Error(`entry.png is ${bytes.length} bytes; the gate allows at most 1048576`);
mkdirSync(outDir, { recursive: true });
writeFileSync(target, bytes);
console.log(`Entry: ${width}x${height}, ${bytes.length} bytes -> ${target}`);
