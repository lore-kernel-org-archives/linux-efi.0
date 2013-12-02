From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 06/12] efi: export efi runtime memory mapping to sysfs
Date: Mon, 2 Dec 2013 10:59:42 +0800
Message-ID: <20131202025942.GF3999@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-7-git-send-email-dyoung@redhat.com>
 <20131127114402.GB32267@pd.tnic>
 <20131129094034.GI4186@dhcp-16-126.nay.redhat.com>
 <20131129115029.GB4266@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131129115029.GB4266-fF5Pk5pvG8Y@public.gmane.org>
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
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/29/13 at 12:50pm, Borislav Petkov wrote:
> No need for the list - I actually meant you simply use a tmp pointer for
> each krealloc invocation - just look around the tree for examples.
> 
> Also think about what happens to the pointed-to memory when krealloc
> returns NULL.

Ok, thanks for the explaination.

> 
> > suppose kexec runtime map preparing fails we still can get 1st kernel
> > boot ok.
> 
> Yeah, nothing stops that - especially if you iterate over the mapped
> regions a second time separately, for kexec.
> 
> Which reminds me, all that save_runtime_map code needs to be behind
> CONFIG_KEXEC. We don't want to be doing this if KEXEC is not enabled.

They are only called if there's setup_data SETUP_EFI passed in. Yes, I think
only kexec need that part of code. But I hesitated to mess the code with
a lot of #if. Will think about it.

Thanks
Dave
