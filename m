From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 1/3 v2] Add function get_bootparam
Date: Tue, 12 Nov 2013 09:26:52 -0500
Message-ID: <20131112142652.GA24980@redhat.com>
References: <20131105082947.500512312@dhcp-16-126.nay.redhat.com>
 <20131105083428.411624560@dhcp-16-126.nay.redhat.com>
 <1384219658.1847.84.camel@misato.fc.hp.com>
 <52819E71.70201@zytor.com> <20131112035344.GA28116@gmail.com>
 <aa0ccca4-b27b-41b6-8adb-3c969eb29bf7@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <aa0ccca4-b27b-41b6-8adb-3c969eb29bf7-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 12, 2013 at 04:58:50PM +1300, Matthew Garrett wrote:
> Well, there's one alternative - don't export this at all and only support UEFI kernels that have an in-kernel loader, then just pass the data internally. 

Hi Matthew,

I am still writing that in-kernel support for kexec/kdump. I guess in
next 2 weeks I might be able to post a basic RFC version. (no EFI support
in this version though).

Having said that, I think that it is good to export these values to
user space and make existing code work with UEFI. New code (if it gets
in at all) will slowly mature over a period of time and transition to it
will be slow. I think initially it will be used only if secureboot is
enabled. And in the mean time we need a good solution for kexec/kdump
with UEFI. 

Thanks
Vivek
