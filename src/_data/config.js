// ENV variables
module.exports = {
  env: process.env.ELEVENTY_ENV || 'production',
  isproduction:
    (process.env.ELEVENTY_ENV || 'production') === 'production' ? true : false,
  info: 'this could be async data which are pulled when building website. if data does not need to be life updated, or updated every 5 or below minutes. Building once they change is ideal for performance.',
}
