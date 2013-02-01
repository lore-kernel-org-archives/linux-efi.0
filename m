From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: CONFIG_GOOGLE_SMI and efivars
Date: Fri, 01 Feb 2013 17:07:22 +0000
Message-ID: <1359738442.7515.82.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hey Mike,

I'm taking a look at the google/gsmi.c code and wondering whether the
CONFIG_GOOGLE_SMI machines are expecting to use both the EFI variable
ops in google/gsmi.c and efivars.c simultaneously? If not, why do we
hang so much state off of "struct efivars"? If these two backends *are*
meant to work at the same time, what happens with things like the pstore
code, which will only work with the first EFI variable backend to be
registered? I think it's the coupling/duplication all this sysfs glue
that is confusing me.

The reason I'm looking at this is because the new efivarfs filesystem
hard-codes access to the __efivars symbol as it just wants to access the
variable ops and serialising lock. It doesn't need any of the sysfs
glue. But it seems rather mean that efivarfs doesn't work with gsmi.c,
since there's no reason it shouldn't work. So I'm trying to understand
your usecases and arrive at a solution that doesn't break your machines,
before I start chainsawing things to kingdom come.

-- 
Matt Fleming, Intel Open Source Technology Center
