Feature: Event Parsing 

  In rbyate should be present a Yate::Event class
  to easily parse received message from the Yate server.

  Scenario Outline: using Yate::Event.from_protocol_text class method
    Given the Yate::Event class method 'from_protocol_text' 
    When his parameter is equal to the Yate <event>
    Then the result value is a Yate::Event instance
    And have attributes: name, etype, direction

    Examples:
    | event                          |
    | %%<watch:call.execute:true     |
    | %%<install:call.execute:true   |
    | %%<message::false:engine.timer::time=1252678200 |
    | %%<message::true:database::account=default:query=UPDATE cdr SET room = 'UNKNOWN', address = '127.0.0.1%z5059', direction = 'outgoing', billid = '1252668723-20', caller = 'AlcaDialer', called = '', duration = '0', billtime = '0', ringtime = '0', status = 'ringing', reason = '' WHERE chan = 'sip/20' AND time = '1252678197':affected=0:dbtype=mysqldb |
    | %%<message::false:call.cdr::time=1252678197:chan=sip/20:cdrid=39:runid=1252668723:operation=update:direction=outgoing:duration=0:billtime=0:ringtime=0:status=ringing:cdrwrite=true:address=127.0.0.1%z5059:caller=AlcaDialer:calledfull=operator:billid=1252668723-20:room=UNKNOWN |
    | %%<message::true:call.execute::module=tone:caller=AlcaDialer:callto=sip/example:id=tone/1:peerid=sip/1:targetid=sip/1 |

  Scenario Outline: accessing event attributes
    Given an event "<event>"
    When create an object with from_protocol_text
    Then the result value has a "<parameter>" parameter
    And his value it is "<value>"

    Examples:
    | event                          | parameter | value |
    | %%<message::false:engine.timer::time=1252678200 | evt_name | engine.timer |
    | %%<message::true:database::account=default:query=UPDATE cdr SET room = 'UNKNOWN', address = '127.0.0.1%z5059', direction = 'outgoing', billid = '1252668723-20', caller = 'AlcaDialer', called = '', duration = '0', billtime = '0', ringtime = '0', status = 'ringing', reason = '' WHERE chan = 'sip/20' AND time = '1252678197':affected=0:dbtype=mysqldb | evt_name | database |
    | %%<message::false:call.cdr::time=1252678197:chan=sip/20:cdrid=39:runid=1252668723:operation=update:direction=outgoing:duration=0:billtime=0:ringtime=0:status=ringing:cdrwrite=true:address=127.0.0.1%z5059:caller=AlcaDialer:calledfull=operator:billid=1252668723-20:room=UNKNOWN | evt_processed | false |
    | %%<message::true:call.execute::module=tone:caller=AlcaDialer:callto=sip/example:id=tone/1:peerid=sip/1:targetid=sip/1 | evt_processed | true |


  Scenario Outline: accessing message parameters
    Given an event "<event>"
    When create an object with from_protocol_text
    Then the result value has a "<parameter>" parameter
    And his value it is "<value>"

    Examples:
    | event                          | parameter | value |
    | %%<message::false:engine.timer::time=1252678200 | msg_time | 1252678200 |
    | %%<message::true:database::account=default:query=UPDATE cdr SET room = 'UNKNOWN', address = '127.0.0.1%z5059', direction = 'outgoing', billid = '1252668723-20', caller = 'AlcaDialer', called = '', duration = '0', billtime = '0', ringtime = '0', status = 'ringing', reason = '' WHERE chan = 'sip/20' AND time = '1252678197':affected=0:dbtype=mysqldb | msg_account | default |
    | %%<message::false:call.cdr::time=1252678197:chan=sip/20:cdrid=39:runid=1252668723:operation=update:direction=outgoing:duration=0:billtime=0:ringtime=0:status=ringing:cdrwrite=true:address=127.0.0.1%z5059:caller=AlcaDialer:calledfull=operator:billid=1252668723-20:room=UNKNOWN | msg_room | UNKNOWN |
    | %%<message::true:call.execute::module=tone:caller=AlcaDialer:callto=sip/example:id=tone/1:peerid=sip/1:targetid=sip/1 | msg_caller | AlcaDialer |
