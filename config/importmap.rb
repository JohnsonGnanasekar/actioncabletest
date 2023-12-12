# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin_all_from 'app/javascript/channels', under: 'channels'

pin "@rails/actioncable", to: "https://ga.jspm.io/npm:@rails/actioncable@7.1.2/app/assets/javascripts/actioncable.esm.js"
