From: Joseph Yasi <joe.yasi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: efivarfs: guid part of filenames are case-insensitive is broken
Date: Mon, 4 Mar 2013 16:46:57 -0500
Message-ID: <CADzA9okmNOS429FJNEAMj7gUMKD9bU8jzznCoJ_=tyySGDE++A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

With linux 3.8.2 I can no longer mount efivars on my Lenovo Thinkpad T530:

$ sudo mount -v /sys/firmware/efi/efivars
mount: Cannot allocate memory

If I revert commit 688289c4b745c018b3449b4b4c5a2030083c8eaf:
"efivarfs: guid part of filenames are case-insensitive", I can once
again mount the filesystem.

Thanks,
Joe Yasi
