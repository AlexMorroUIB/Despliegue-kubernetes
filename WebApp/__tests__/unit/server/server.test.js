const health = require('../../../server.js')

test('server returns code 200', () => {
  expect(health()).toBe(200)
})
