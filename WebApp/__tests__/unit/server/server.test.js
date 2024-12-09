const sum = require('../../../test.js')

test('server returns code 200', () => {
  expect(sum(2, 3)).toBe(5)
})
