getHealth()
async function getHealth () {
  try {
    await fetch('/health')
        .then(response => {
          process.stdout.write(response.status)
        })
        .catch(err => {
          process.stderr.write(err)
        })
  } catch (err) {
    process.stderr.write(err)
  }
}