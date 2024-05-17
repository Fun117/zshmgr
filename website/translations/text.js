import { _config } from "../_config";

/**
 * @typedef {"ja"} DefaultLocale
 * @typedef {DefaultLocale | "en-US"} Locale
 */

/** @type {Readonly<Record<Locale, string>>} */
export const languageMap = {
  ja: "日本語",
  "en-US": "English",
};

/** @type {Readonly<Record<Locale, string>>} */
export const titleMap = {
  ja: "Zsh用のシンプルなパッケージマネージャーです",
  "en-US": "Simple package manager for Zsh.",
};

/** @type {Readonly<Record<Locale, string>>} */
export const headDescriptionMap = {
  ja: "Zshmgr は、Zsh用のシンプルなパッケージマネージャーです。ユーザーはパッケージのインストール、アンインストール、アップデート、リスト表示を簡単に行うことができます。このツールはGitHubリポジトリとシームレスに連携するように設計されており、Zshスクリプトやツールの管理が容易になります。",
  "en-US":
    "Zshmgr is a simple package manager for Zsh. It allows users to easily install, uninstall, update, and list packages. The tool is designed to work seamlessly with GitHub repositories, making it easy to manage your Zsh scripts and tools.",
};

/** @type {Readonly<Record<Locale, string>>} */
export const feedbackLinkMap = {
  ja: "ご質問は？ご意見をお聞かせください。",
  "en-US": "Question? Give us feedback →",
};

/** @type {Readonly<Record<Locale, string>>} */
export const editTextMap = {
  ja: "Github で編集する →",
  "en-US": "Edit this page on GitHub →",
};

/** @type {Readonly<Record<Locale, { text: string; copyright?: string }>>} */
export const footerTextMap = {
  ja: {
    text: "提供",
    copyright: `著作権 © ${new Date().getFullYear()} ${
      _config.author.name
    }.
    Nextraで構築されています。`,
  },
  "en-US": {
    text: "Powered by",
    copyright: `Copyright © ${new Date().getFullYear()} ${
      _config.author.name
    }.
  Built with Nextra.`,
  },
};

/** @type {Readonly<Record<Locale, string>>} */
export const tableOfContentsTitleMap = {
  ja: "このページについて",
  "en-US": "On This Page",
};

/** @type {Readonly<Record<Locale, string>>} */
export const searchPlaceholderMap = {
  ja: "ドキュメントを検索...",
  "en-US": "Search documentation...",
};

/** @type {Readonly<Record<Locale, string>>} */
export const gitTimestampMap = {
  ja: "最終更新日",
  "en-US": "Last updated on",
};
