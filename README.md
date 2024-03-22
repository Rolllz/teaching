Домашнее задание. Практика с SELinux

Цель домашнего задания

    -  диагностировать проблемы и модифицировать политики SELinux для корректной работы приложений, если это требуется;

Описание домашнего задания

  Обеспечить работоспособность приложения при включенном SELinux^
  
    развернуть приложенный стенд https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems;
    выяснить причину неработоспособности механизма обновления зоны (см. README);
    предложить решение (или решения) для данной проблемы;
    выбрать одно из решений для реализации, предварительно обосновав выбор;
    реализовать выбранное решение и продемонстрировать его работоспособность.

  В данном задании у машины ns01 была проблема с контекстом безопасности файлов и директорий. Конкретно - тип метки.
  Поменять метку файла можно двумя способами:

    1. Командой chcon: временное изменение контекста безопасности;
    2. Командой semanage: добавление нового правила для файлового контекста и последующей командой restorecon для восстановления контекста безопасности по новому правилу.

  В случае, если необходимо делать постоянные обновления DNS зон, то нужно воспользоваться вторым способом. Однако если это нужно исключительно для проверки, то подойдет и первый.

  Для данного стенда можно добавить два таска для сервера ns01 следующего содержания:
  
```yaml
    - name: Allow client to update DNS zone
      sefcontext:
        target: '/etc/named(/.*)?'
        setype: named_zone_t
        state: present
  
    - name: Apply new SELinux file context to filesystem
      command: restorecon -irv /etc/named
```

  В случае, если необходима разовая проверка, то достаточно только добавить второй таск, только с измененной командой:

```yaml
    -name: Change SELinux file context
      command: chcon -R -t named_zone_t /etc/named
```
