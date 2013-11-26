From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 0/4 v3] kexec-tools: efi runtime support
Date: Tue, 26 Nov 2013 14:11:24 +0800
Message-ID: <20131126061124.GB9727@dhcp-16-126.nay.redhat.com>
References: <20131121064043.969000753@dhcp-16-126.nay.redhat.com>
 <1385159448.1791.161.camel@misato.fc.hp.com>
 <20131124031228.GA1754@dhcp-16-126.nay.redhat.com>
 <1385393451.1791.168.camel@misato.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1385393451.1791.168.camel-RbGIw1UOYPVo/CpIj0byZw@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi, Toshi
On 11/25/13 at 08:30am, Toshi Kani wrote:
> HI Dave,
> 
> I will test v4 again.  This time, I will test "memmap=exactmap" option
> as well.  I have tested the following cases before.  Are there any other
> cases you'd like me to test?
> 
>  - kdump
>  - multiple fast reboots and then kdump
>  - old kexec and new kernel w/ noefi & acpi_rsdp option
>  - new kexec and old kernel w/ noefi & acpi_rsdp option

There's one more test case is w/ debugfs mounted in 1st kernel due to the
new version exports setup_data to sysfs.

For the exactmap I think it's a corner case, I just tested it in virtual
machine I think setup a right cmdline is hard. But feel free to test it if
you can.

Thanks
Dave
