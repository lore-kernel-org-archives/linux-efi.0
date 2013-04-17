From: joeyli <jlee@suse.com>
Subject: Re: Cannot add new efi boot entry
Date: Wed, 17 Apr 2013 19:33:17 +0800
Message-ID: <1366198397.23707.68.camel@linux-s257.site>
References: <516B1ED3.9040900@suse.cz>
	 <1366106168.23707.9.camel@linux-s257.site>  <516D23B5.4070209@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <516D23B5.4070209@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>, matthew.garrett@nebula.com, cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org, Tony Luck <tony.luck@intel.com>, linux-efi@vger.kernel.org, Linux kernel mailing list <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=8C=EF=BC=8C2013-04-16 =E6=96=BC 11:11 +0100=EF=BC=8CMa=
tt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
> On 16/04/13 10:56, joeyli wrote:
> > I think I just got the same situation on my side with Acer machine.=
 I am
> > trying Matthew's new patchset hope can avoid this situation:
> >=20
> > https://lkml.org/lkml/2013/4/15/473
>=20
> Please do let us know whether the patches work for you.
>=20
>=20

I applied Matthew's patches to v3.9-rc7 then tested...

The active_size checking works to me on my Acer machine for avoid the
storage_size/2 issue, I can use efibootmgr to create new boot entry,
now.

But, I found there have the following warning:

[    1.347581] [Firmware Bug]: efi: Inconsistent initial size

Then, I add printk to print the values of var_size and active_size,
found the values always 0 after system reboot. I am doing to add more
log for locate if this is a BIOS issue.


Thanks a lot!
Joey Lee
