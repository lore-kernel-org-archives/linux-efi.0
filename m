From: Maciej Piechotka <uzytkownik2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Cannot get EFI Pstore to work but there is no indication of what is wrong
Date: Sat, 3 Sep 2016 11:56:50 -0700
Message-ID: <CAMcAH6gXNM+c+H=Lqt=bFhMq4txaossZbfTspwN8AFGTmQcL5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

I'm trying to debug some late-suspend hang. However while I tried to
use pstore it doesn't seems to work with no indication why:

% dmesg| grep -i pstore
[    1.736649] pstore: Registered efi as persistent store backend
% cat /sys/module/pstore/parameters/backend
efi
% zcat /proc/config.gz | grep -i PSTORE
CONFIG_EFI_VARS_PSTORE=y
# CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
CONFIG_PSTORE_RAM=y
% ls /sys/fs/pstore -al
total 0
drwxr-xr-x 2 root root 0 Sep  2 11:06 .
drwxr-xr-x 8 root root 0 Sep  2 11:06 ..
% sudo touch /sys/fs/pstore/foo
touch: cannot touch '/sys/fs/pstore/foo': Permission denied
% mount | grep pstore
pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime)

Any idea why I cannot get pstore to work?
