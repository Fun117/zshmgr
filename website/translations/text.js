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
  ja: "データ取得のための React Hooks ライブラリ",
  "en-US": "React Hooks for Data Fetching",
};

/** @type {Readonly<Record<Locale, string>>} */
export const headDescriptionMap = {
  ja: "SWRはデータフェッチ用のReact Hooksライブラリです。SWRはまずキャッシュからデータを返し（stale）、次にフェッチリクエストを送り（revalidate）、最後に再び最新のデータを持ってくる。",
  "en-US":
    "SWR is a React Hooks library for data fetching. SWR first returns the data from cache (stale), then sends the fetch request (revalidate), and finally comes with the up-to-date data again.",
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
