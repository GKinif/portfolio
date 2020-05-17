const purgecss = require('@fullhuman/postcss-purgecss')({
  // Specify the paths to all of the template files in your project
  content: [
    '../**/*.html.eex',
    '../**/*.html.leex',
    '../**/views/**/*.ex',
    './js/**/*.js'
  ],

  // Only purge app.css to prevent purging lightgallery
  whitelistPatterns: [
    /^lg-/,
    /^cropper-/,
    /^dashed-h/,
    /^dashed-v/,
    /^line-e/,
    /^line-n/,
    /^line-w/,
    /^line-s/,
    /^point-e/,
    /^point-n/,
    /^point-w/,
    /^point-s/,
    /^point-ne/,
    /^point-nw/,
    /^point-sw/,
    /^point-se/,

  ],

  // Include any special characters you're using in this regular expression
  defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || []
})

module.exports = {
  plugins: [
    require('tailwindcss'),
    require('autoprefixer'),
    ...process.env.NODE_ENV === 'production'
      ? [purgecss]
      : []
  ]
}