/**
 * /prev <file> — open a Markdown file in Learn and keep it live.
 *
 * Install this file in ~/.pi/agent/extensions/ to make the command available
 * in every Pi session.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { spawn } from "node:child_process";
import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";

const developmentBinary = "/Users/clements/Documents/Codex/2026-08-27/referenced-chatgpt-conversation-this-is-an/src-tauri/target/release/learn";

function expandHome(filepath: string): string {
	return filepath === "~" || filepath.startsWith("~/")
		? path.join(os.homedir(), filepath.slice(2))
		: filepath;
}

function learnExecutable(): string | undefined {
	const candidates = [
		process.env.LEARN_BIN,
		path.join(os.homedir(), "Applications", "Learn.app", "Contents", "MacOS", "learn"),
		"/Applications/Learn.app/Contents/MacOS/learn",
		"/opt/homebrew/bin/learn",
		"/usr/local/bin/learn",
		path.join(os.homedir(), ".local", "bin", "learn"),
		developmentBinary,
	];

	return candidates.find((candidate): candidate is string => Boolean(candidate) && fs.existsSync(candidate));
}

export default function prev(pi: ExtensionAPI) {
	pi.registerCommand("prev", {
		description: "Preview a Markdown file live in Learn: /prev <file>",
		handler: async (args, ctx: any) => {
			const requested = args.trim();
			if (!requested) {
				ctx.ui.notify("Usage: /prev <file>", "warning");
				return;
			}

			const expanded = expandHome(requested);
			const resolved = path.isAbsolute(expanded) ? expanded : path.resolve(ctx.cwd, expanded);
			if (!fs.existsSync(resolved)) {
				ctx.ui.notify(`Preview file does not exist: ${resolved}`, "error");
				return;
			}
			if (!fs.statSync(resolved).isFile()) {
				ctx.ui.notify(`Preview target is not a file: ${resolved}`, "error");
				return;
			}
			if (!/\.(md|markdown)$/i.test(resolved)) {
				ctx.ui.notify("Learn can only preview .md and .markdown files.", "error");
				return;
			}

			const executable = learnExecutable();
			if (!executable) {
				ctx.ui.notify("Learn is not installed. Set LEARN_BIN or install Learn.app in Applications.", "error");
				return;
			}

			const child = spawn(executable, [fs.realpathSync(resolved)], {
				detached: true,
				stdio: "ignore",
			});
			child.once("error", (error) => {
				ctx.ui.notify(`Could not launch Learn: ${error.message}`, "error");
			});
			child.unref();
			ctx.ui.notify(`Previewing: ${path.basename(resolved)}`, "success");
		},
	});
}
