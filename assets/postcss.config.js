const purgecss = require("@fullhuman/postcss-purgecss")({
  // Specify the paths to all of the template files in your project
  content: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "./js/**/*.js",
    "./js/**/*.svelte",
  ],

  whitelistPatterns: [
    // Whitelist lightgallery css
    /^lg-/,
    // Whitelist cropper.js css
    /^cropper-/,
    // Whitelist tippy css
    /tippy/,
    /^svelte-/,
  ],
  whitelistPatternsChildren: [/tippy/, /cropper/, /svelte/],

  // Include any special characters you're using in this regular expression
  defaultExtractor: (content) => content.match(/[\w-/:]+(?<!:)/g) || [],
});

module.exports = {
  plugins: [
    require("tailwindcss"),
    require("autoprefixer"),
    ...(process.env.NODE_ENV === "production" ? [purgecss] : []),
  ],
};
