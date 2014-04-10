From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: df36ac1bc2a16 ("pstore: Don't allow high traffic options on fragile
 devices")
Date: Thu, 10 Apr 2014 20:15:03 +0200
Message-ID: <20140410181503.GA4704@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hey Tony,

so I was wondering whether we could finally put that UEFI thing to use
and log dmesg into it but then Matt pointed me to df36ac1bc2a16.

Even though those nvram devices are fragile and can only stomach a
limited amount of writes, wouldn't it be a nifty feature to have a
kernel cmdline param of the sort "put_dmesg_in_nvram_this_one_time_only"
which logs to nvram only once for debugging purposes.

The usecase I have in mind is all those laptops which are sporting UEFI
now and where logging to serial or netconsole or something else is
simply not an option, for whatever reason (I'm sure anyone can think of
a number of those). If we had this, it would be one step closer to the
holy grail of being able to catch dmesg even on laptops.

We could also add checks like if efivarfs already has a dump-type* file
to not log, etc etc. Eventually, it would be a user decision whether to
still log to nvram or not, i.e. brick her laptop or not.

Thoughts?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
