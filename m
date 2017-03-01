From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v1 1/2] efi/capsule: Add 'capsule' lookup support
Date: Wed, 1 Mar 2017 20:46:32 +0000
Message-ID: <20170301204632.GG28416@codeblueprint.co.uk>
References: <20170228174528.23542-1-qiuxu.zhuo@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170228174528.23542-1-qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 01 Mar, at 01:45:27AM, Qiuxu Zhuo wrote:
> Add the interface to get the array of EFI capsules when
> parsing the configuration tables.
> 
> This code is based on Matt Fleming previous work from:
> https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=capsule-pstore&id=99c5f047133555aa0442f64064e85b7da2d4a45f
> 
> Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/capsule.c | 107 +++++++++++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/efi.c     |   4 ++
>  include/linux/efi.h            |   4 ++
>  3 files changed, 115 insertions(+)

Please remove this SoB line. You've modified the code enough that my
SoB doesn't belong here.
