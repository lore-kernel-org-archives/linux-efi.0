From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v4] efivars,efi-pstore: Hold off deletion of sysfs entry
 until the scan is completed
Date: Wed, 6 Nov 2013 08:51:27 +0000
Message-ID: <20131106085127.GB22856@console-pimps.org>
References: <52715D9E.10701@hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52715D9E.10701-7rDLJAbr9SE@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tomoki.sekiyama-7rDLJAbr9SE@public.gmane.org, dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 30 Oct, at 03:27:26PM, Seiji Aguchi wrote:
>  drivers/firmware/efi/efi-pstore.c | 143 +++++++++++++++++++++++++++++++++++---
>  drivers/firmware/efi/efivars.c    |  12 ++--
>  drivers/firmware/efi/vars.c       |  12 +++-
>  include/linux/efi.h               |   4 ++
>  4 files changed, 155 insertions(+), 16 deletions(-)

Tony, want me to pick this up since it touches various EFI bits?

-- 
Matt Fleming, Intel Open Source Technology Center
