From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 3/6] Cleanup efi_enter_virtual_mode function
Date: Mon, 28 Oct 2013 23:10:48 +0800
Message-ID: <20131028151048.GA14984@dhcp-16-126.nay.redhat.com>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035923.081819853@dhcp-16-126.nay.redhat.com>
 <20131028093206.GB4314@pd.tnic>
 <20131028094049.GC25527@dhcp-16-126.nay.redhat.com>
 <20131028095117.GD25527@dhcp-16-126.nay.redhat.com>
 <20131028100402.GC4314@pd.tnic>
 <20131028101011.GF25527@dhcp-16-126.nay.redhat.com>
 <20131028112045.GH4314@pd.tnic>
 <20131028112458.GD29133@dhcp-16-126.nay.redhat.com>
 <20131028145801.GM4314@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131028145801.GM4314-fF5Pk5pvG8Y@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 10/28/13 at 03:58pm, Borislav Petkov wrote:
> On Mon, Oct 28, 2013 at 07:24:58PM +0800, Dave Young wrote:
> > I use linus tree, git pull Matt's efi-next tree, then apply your 12
> > patches and my patches. I applied your previous 11 patches + the last
> > update patch 12/12, but the last one does not apply, I manually shift
> > a hunk to make it apply.
> 
> Nope, still doesn't apply.
> 
> patch -p1 --dry-run -i ~/efi/dy/03-efi-enter-virtual-mode-cleanup.patch 
> checking file arch/x86/platform/efi/efi.c
> Hunk #1 succeeded at 788 (offset -1 lines).
> Hunk #2 succeeded at 821 (offset -1 lines).
> Hunk #3 FAILED at 853.
> 1 out of 3 hunks FAILED
> 
> and this time I took your patches from here: https://people.redhat.com/ruyang/kexec-efi/for-bp/kernel-patches/
> 
> What I did is:
> 
> 1. I took Linus' tree from today
> 
> 2. Merged the 'next' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git. Mind
> you, not the 'efi-next' tag!

I used the above tree origin/next branch

> 
> 3. Then I merged the 'efi' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git ontop.

I used the patches from mailbox directly.
Fixed an conflict and merge them one by one.

> It gave a simple merge conflict which is trivial to resolve:
> http://paste.debian.net/62579/

Looks like I can not access above link.

> 
> Here I started applying your patches and the 3rd one still fails.
> 

It's strange to me. There must be something wrong in the steps
But sorry, it's time to sleep for me, will track this tommrrow.

Thanks
Dave
