From: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [patch 0/4 v3] kexec-tools: efi runtime support
Date: Tue, 26 Nov 2013 08:59:13 -0700
Message-ID: <1385481553.1791.179.camel@misato.fc.hp.com>
References: <20131121064043.969000753@dhcp-16-126.nay.redhat.com>
	 <1385159448.1791.161.camel@misato.fc.hp.com>
	 <20131124031228.GA1754@dhcp-16-126.nay.redhat.com>
	 <1385393451.1791.168.camel@misato.fc.hp.com>
	 <20131126061124.GB9727@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131126061124.GB9727-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-11-26 at 14:11 +0800, Dave Young wrote:
> On 11/25/13 at 08:30am, Toshi Kani wrote:
> > HI Dave,
> > 
> > I will test v4 again.  This time, I will test "memmap=exactmap" option
> > as well.  I have tested the following cases before.  Are there any other
> > cases you'd like me to test?
> > 
> >  - kdump
> >  - multiple fast reboots and then kdump
> >  - old kexec and new kernel w/ noefi & acpi_rsdp option
> >  - new kexec and old kernel w/ noefi & acpi_rsdp option

Retested the above cases with v4 patchset.

> There's one more test case is w/ debugfs mounted in 1st kernel due to the
> new version exports setup_data to sysfs.

Tested w/ debugfs mounted.

> For the exactmap I think it's a corner case, I just tested it in virtual
> machine I think setup a right cmdline is hard. But feel free to test it if
> you can.

Tested with exactmap for multiple fast reboots.  I was not able to setup
kdump properly with this case, but it's not related with your changes
since I was not able to do it without your changes, either.

Feel free to add my tested-by.

Thanks,
-Toshi
