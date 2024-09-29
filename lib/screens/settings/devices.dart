import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/components/blur_app_bar.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:laber_app/state/bloc/devices_bloc.dart';
import 'package:laber_app/state/types/devices_state.dart';

class Devices extends StatefulWidget {
  const Devices({super.key});

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  late AuthBloc authBloc;
  final devicesBloc = DevicesBloc();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authBloc = context.watch<AuthBloc>();
  }

  @override
  void initState() {
    super.initState();
    devicesBloc.add(FetchDevicesDevicesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesBloc, DevicesState>(
      bloc: devicesBloc,
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: const BlurAppBar(title: "Linked Devices"),
          body: RefreshIndicator(
            onRefresh: () async {
              devicesBloc.add(FetchDevicesDevicesEvent(artificialDelay: true));
              return () async {
                var loopCount = 0;
                do {
                  await Future.delayed(const Duration(milliseconds: 100));
                  if (++loopCount > 30) break;
                } while (devicesBloc.state.state == DevicesStateEnum.loading);
                return;
              }();
            },
            color: Colors.white,
            edgeOffset: 100,
            child: ListView(
              children: <Widget>[
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[900],
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              "Link a New Device",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey[400],
                              size: 14,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Builder(builder: (context) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[900],
                    ),
                    child: Column(
                      children: <Widget>[
                        for (var device in state.getSortedDevices(
                          authBloc.state.meDevice?.id ?? '',
                        ))
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    (device.deviceName ?? ''),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (device.id ==
                                      authBloc.state.meDevice?.id) ...[
                                    const SizedBox(width: 2),
                                    Text(
                                      "(This Device)",
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Created at: ${device.createdAtString}',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'Remaining onetime Prekeys: ${device.oneTimePreKeys?.length.toString() ?? "NOT FOUND"}',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "Id: ${device.id ?? "NOT FOUND"}",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            trailing: (device.id != authBloc.state.meDevice?.id
                                ? IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      print("Delete device");
                                      /*
                                  devicesBloc
                                      .add(DeleteDeviceDevicesEvent(device.id));
                                  */
                                    },
                                  )
                                : const SizedBox()),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          /*
          body: ListView(

            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    for (var device in state.devices)
                      ListTile(
                        title: Text(device.deviceName ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: device.id == authBloc.state.meDevice?.id
                                  ? Colors.red
                                  : Colors.white,
                            )),
                        subtitle: Text(device.id ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            print("Delete device");
                            /*
                            devicesBloc
                                .add(DeleteDeviceDevicesEvent(device.id));
                          */
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
            */
        );
      },
    );
  }
}
