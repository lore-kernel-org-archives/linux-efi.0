From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: efivarfs: guid part of filenames are case-insensitive is broken
Date: Tue, 05 Mar 2013 16:38:03 +0800
Message-ID: <5135AEEB.9090408@redhat.com>
References: <CADzA9okmNOS429FJNEAMj7gUMKD9bU8jzznCoJ_=tyySGDE++A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADzA9okmNOS429FJNEAMj7gUMKD9bU8jzznCoJ_=tyySGDE++A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Joseph Yasi <joe.yasi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/05/2013 05:46 AM, Joseph Yasi wrote:
> Hi,
> 
> With linux 3.8.2 I can no longer mount efivars on my Lenovo Thinkpad T530:
> 
> $ sudo mount -v /sys/firmware/efi/efivars
> mount: Cannot allocate memory

Looking at 47f531e8ba3bc3901a0c493f4252826c41dea1a1
efivarfs: Validate filenames much more aggressively

In efivarfs_valid_name:

+	/* GUID should be right after the first '-' */
+	if (s - 1 != strchr(str, '-'))
+		return false;

But pstore creates entries like dump-type0-1-$timestamp-$GUID.

efivarfs_alloc_dentry fails because it thinks pstore entry names
are invalid.

EFI pstore dump is now enabled by default (as in Fedora), saving
dump sooner or later, so users will likely be affected by this.

Manually creating a test-test-$GUID also reproduces this.


Lingzhu Xiang
