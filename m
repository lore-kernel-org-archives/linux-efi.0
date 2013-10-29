From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 5/6] export efi runtime memory mapping to sysfs
Date: Tue, 29 Oct 2013 13:34:27 +0800
Message-ID: <20131029053427.GH5185@dhcp-16-126.nay.redhat.com>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035923.442470867@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131027035923.442470867-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 10/27/13 at 11:47am, Dave Young wrote:
> kexec kernel will need exactly same mapping for
> efi runtime memory ranges. Thus here export the
> runtime ranges mapping to sysfs, kexec-tools
> will assemble them and pass to 2nd kernel via
> setup_data.
> 
> Introducing a new directly /sys/firmware/efi/efi-runtime-map
> Just like /sys/firmware/memmap. Containing below attribute
> in each file of that directory:
> attribute  num_pages  phys_addr  type  virt_addr
> 
> It will not work for efi 32bit. Only x86_64 currently.
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/include/asm/efi.h             |    3 
>  arch/x86/platform/efi/efi.c            |   11 ++
>  drivers/firmware/efi/Kconfig           |   10 +
>  drivers/firmware/efi/Makefile          |    1 
>  drivers/firmware/efi/efi-runtime-map.c |  166 +++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/efi.c             |    3 
>  6 files changed, 193 insertions(+), 1 deletion(-)

Remind myself: add below to Documentaion in next version:
Documentation/ABI/testing/sysfs-efi-runtime-map
