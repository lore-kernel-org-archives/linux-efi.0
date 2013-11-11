From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 0/7 v2] kexec kernel efi runtime support
Date: Mon, 11 Nov 2013 10:13:56 +0800
Message-ID: <20131111021356.GC4407@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131108143118.GA22636@console-pimps.org>
 <20131109035739.GB4294@dhcp-16-126.nay.redhat.com>
 <527DC1BE.6030107@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <527DC1BE.6030107-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/08/13 at 09:01pm, H. Peter Anvin wrote:
> On 11/08/2013 07:57 PM, Dave Young wrote:
> > 
> > Hmm, if CONFIG_DEBUG_BOOT_PARAMS is not set, then kexec-tools should
> > fail getting efi_info, so I will fix kexec-tools patch about this.
> > 
> > Also CONFIG_EFI_RUNTIME_MAP should select CONFIG_DEBUG_BOOT_PARAMS.
> > In future will try to move the boot params data out of debugfs. 
> > 
> 
> Honestly, if we need debugfs to get actual functionality, it shouldn't
> be in sploit^Wdebugfs...
> 

Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> created the debugfs file for boot_params.
His first version patch tried sysfs, but sysfs is not designed for such
binary blobs so finally it go to debugfs.

Any idea for this is welcome, till now I have no better idea for such kind
of data. We should have another *fs instead of using debugfs.

Thanks
Dave
