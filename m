From: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Date: Thu, 19 Dec 2013 17:04:45 +0100
Message-ID: <20131219170445.42b50a5b@linux.lan.towertech.it>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	<52B309EB.90300@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52B309EB.90300-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 19 Dec 2013 06:59:55 -0800
"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:

> EFI time is something we used to support and ripped out, because it
> doesn't work well, *at all*.
> 
> I am hyper-skeptical to reintroducing them, and *definitely* will veto
> reintroducing them on a system which has PNP0B0x devices present.

 Definitely agree.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it
