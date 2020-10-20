#!/usr/bin/env python3                                                                                                                                # -*- coding: utf-8 -*-
import json
import sys


def main(args: list):
    with open(args[0], 'r') as youtube_checker, open(args[1], 'w') as newpipe_subscriptions:
        youtube_checker_data = json.load(youtube_checker)
        newpipe_data = {'app_version': '0.18.0', 'app_version_int': 800, 'subscriptions': []}
        for entry in youtube_checker_data['channels']:
            newpipe_data['subscriptions'].append({'service_id': 0, 'url': f'https://www.youtube.com/channel/{entry["id"]}', 'name': entry['title']})
        json.dump(newpipe_data, newpipe_subscriptions)


if __name__ == '__main__':
    if len(sys.argv) == 3:
        main(sys.argv[1:])
    else:
        print(f'Usage: sys.argv[0] subs.json newpipe-subscriptions.json')
        exit(1)
