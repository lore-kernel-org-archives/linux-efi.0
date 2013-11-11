From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 0/7 v2] kexec kernel efi runtime support
Date: Mon, 11 Nov 2013 10:47:01 +0800
Message-ID: <20131111024701.GD4407@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131108143118.GA22636@console-pimps.org>
 <20131109035739.GB4294@dhcp-16-126.nay.redhat.com>
 <527DC1BE.6030107@zytor.com>
 <20131111021356.GC4407@dhcp-16-126.nay.redhat.com>
 <52803F15.3080204@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52803F15.3080204-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
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
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/10/13 at 06:21pm, H. Peter Anvin wrote:
> On 11/10/2013 06:13 PM, Dave Young wrote:
> > 
> > Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> created the debugfs file for boot_params.
> > His first version patch tried sysfs, but sysfs is not designed for such
> > binary blobs so finally it go to debugfs.
> > 
> 
> That is a misunderstanding.  Binary blobs can exist in sysfs as long as
> the blob is something that is inherently a blob.  This is admittedly a
> corner case, but it is without any doubt a protocol-defined binary
> structure.

You are right. Greg objected that the whole structure being exported directly.

> 
> The reason it was put in debugfs is that there was no non-debug user for
> it at the time.

Ok, I did not know this background.

> 
> > Any idea for this is welcome, till now I have no better idea for such kind
> > of data. We should have another *fs instead of using debugfs.
> 
> The problem with debugfs is that things go into debugfs with largely no
> auditing.  As a result, mounting debugfs is very likely to mean that
> your system is exploitable one way or another.

Hmm, agree. Thanks for explaining about it.

Thanks
Dave
