From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 0/4] kexec-tools: efi runtime support on kexec kernel
Date: Tue, 21 Jan 2014 14:13:14 +0800
Message-ID: <20140121061314.GC5890@dhcp-16-126.nay.redhat.com>
References: <1387533947-18210-1-git-send-email-dyoung@redhat.com>
 <20140121025536.GA5544@dhcp-16-126.nay.redhat.com>
 <20140121050729.GA5152@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140121050729.GA5152-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Simon Horman <horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01/21/14 at 02:07pm, Simon Horman wrote:
> On Tue, Jan 21, 2014 at 10:55:36AM +0800, Dave Young wrote:
> > Hi, Simon
> > 
> > The kernel patches has been merged into Linus tree, could you take a look
> > at these kexec-tools patches and merge them if there's no more comments?
> > 
> > Patch 4/4 was resended in a reply to original 4/4, the subject is:
> > [PATCH v4 4/4 update] Passing efi related data via setup_data
> > These patches has been tested by Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
> > 
> > If you need I resend them please let me know.
> 
> Thanks Dave,
> 
> I have applied the four patches.
> Please double check to make sure that I got the correct version
> of each patch.

Hi, Simon

Verified the patches and tested with qemu.

Thanks a lot
Dave
