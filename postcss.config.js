module.exports = {
    plugins: [
        require('postcss-import'),
        require('tailwindcss/nesting'),
        require('tailwindcss'),
        require('autoprefixer'),
        ...(process.env.NODE_ENV === 'production'
            ? [require('@fullhuman/postcss-purgecss')({
                content: ['./_site/**/*.html'],
                defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || []
            })
            ]
            : [])
    ]
}