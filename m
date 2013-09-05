From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3 03/11] x86: Lock down IO port access when module security
 is enabled
Date: Wed, 04 Sep 2013 20:52:08 -0700
Message-ID: <5227FFE8.5050102@zytor.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com> <1378252218-18798-4-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378252218-18798-4-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 09/03/2013 04:50 PM, Matthew Garrett wrote:
> IO port access would permit users to gain access to PCI configuration
> registers, which in turn (on a lot of hardware) give access to MMIO register
> space. This would potentially permit root to trigger arbitrary DMA, so lock
> it down by default.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>

Seriously... just deny CAP_SYS_RAWIO to any system in secure mode.

	-hpa
