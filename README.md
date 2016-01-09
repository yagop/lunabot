### Warning
This is under development, use at your own risk, many things may change in the future.
Many ideas are taken from [Hubot](https://github.com/github/hubot).
The reason of the proyect is to apply the experience taken from [telegram-bot](https://github.com/yagop/telegram-bot) and write a much more versatile bot. Other goal of the proyect is providing an easy plugin development.

### Running
Before all, install [telegram-cli](https://github.com/vysheng/tg) dependencies.

```
git clone https://github.com/LunaBot/lunabot.git
cd lunabot
git submodule update --init --recursive
cd tg && ./configure && make && cd ..
./install.sh
./launch.sh
```
