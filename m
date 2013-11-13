From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [patch 6/7 v2] passing kexec necessary efi data via setup_data
Date: Wed, 13 Nov 2013 15:50:32 +0000
Message-ID: <20131113155032.GD17248@console-pimps.org>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082718.837997775@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131105082718.837997775-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 05 Nov, at 04:20:13PM, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> Add a new setup_data type SETUP_EFI for kexec use.
> Passing the saved fw_vendor, runtime, config tables and
> efi runtime mappings.
> 
> When entering virtual mode, directly mapping the efi
> runtime ragions which we passed in previously. And skip
> the step to call SetVirtualAddressMap.
> 
> Specially for HP z420 workstation it need another variable
> saving, it's the smbios physical address, the HP bios
> also update the SMBIOS address after entering virtual mode
> besides of the standard fw_vendor,runtime and config table.
 
Does that mean that on some of the platforms you tested the SMBIOS
address isn't updated?

-- 
Matt Fleming, Intel Open Source Technology Center
