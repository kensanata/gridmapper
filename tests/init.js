module.exports = {
  'Setup Help Screen' : function (browser) {
    browser
      .url('file://' + process.cwd() + '/gridmapper.svg')
      .waitForElementVisible('g#help', 1000)
      .assert.containsText('#help', 'Alex Schroeder')
      .end();
  }
};
