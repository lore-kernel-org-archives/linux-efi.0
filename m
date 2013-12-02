From: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH v4 07/12] efi: passing kexec necessary efi data via
 setup_data
Date: Mon, 02 Dec 2013 15:33:20 -0700
Message-ID: <1386023600.1791.201.camel@misato.fc.hp.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-8-git-send-email-dyoung@redhat.com>
 <20131127140732.GD32267@pd.tnic>
 <20131129091415.GH4186@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20131129091415.GH4186-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 2013-11-29 at 17:14 +0800, Dave Young wrote:
> On 11/27/13 at 03:07pm, Borislav Petkov wrote:
> > On Tue, Nov 26, 2013 at 01:57:52PM +0800, Dave Young wrote:
> > > Add a new setup_data type SETUP_EFI for kexec use.
> > > Passing the saved fw_vendor, runtime, config tables and
> > > efi runtime mappings.
> > > 
> > > When entering virtual mode, directly mapping the efi
> > > runtime ragions which we passed in previously. And skip
> > > the step to call SetVirtualAddressMap.
> > > 
> > > Specially for HP z420 workstation it need another variable
> > > saving,
> > 
> > Why the special handling? Does that mean, this is going to be the case
> > for other HP UEFI implementations too?
> 
> I have only one HP machine for testing, Maybe Toshi can help to verify
> on other machines. Just comment out the function efi_reuse_config to see
> if kexec kernel panic.

My system (HP prototype server) did not need the special handling in
efi_reuse_config().  I will check with firmware team to get more
information on this.

Thanks,
-Toshi
