From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86, efi: change name of efi_no_storage_paranoia
 parameter to efi_storage_paranoia
Date: Fri, 8 Nov 2013 14:34:21 +0000
Message-ID: <20131108143421.GB22636@console-pimps.org>
References: <527C93B5.7010407@jp.fujitsu.com>
 <527C9B5C.6040509@nod.at>
 <527CB013.30200@jp.fujitsu.com>
 <527CB0F4.8080606@nod.at>
 <527CBC05.6080505@jp.fujitsu.com>
 <527CBD01.1000908@nod.at>
 <527CBDD3.2020609@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <527CBDD3.2020609-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 08 Nov, at 07:32:51PM, Yasuaki Ishimatsu wrote:
> > Everything started with an issue that killed Samsung laptops:
> > http://mjg59.dreamwidth.org/22855.html
> > 
> > Later it was found that if you write too much into UEFI variables many
> > UEFI implementations will do bad things.
> 
> Thanks for the information.
> I will read it.

Out of curiosity, what hardware are you using?

-- 
Matt Fleming, Intel Open Source Technology Center
