import { copyFileSync } from 'node:fs';
import { join } from 'node:path';

// Copy the rendered poster into the make.fun output directory.
// The platform sets MAKEFUN_OUTPUT_DIR; local runs fall back to /output.
const outputDir = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';
copyFileSync(new URL('./entry.png', import.meta.url), join(outputDir, 'entry.png'));
