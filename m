From: Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH] efivars: Fix check for CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE
Date: Fri, 22 Mar 2013 20:14:25 +0000
Message-ID: <514CBBA1.4040100@intel.com>
References: <1363982211.3728.38.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1363982211.3728.38.camel@deadeye.wl.decadent.org.uk>
Sender: stable-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-efi@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 22/03/13 19:56, Ben Hutchings wrote:
> The 'CONFIG_' prefix is not implicit in IS_ENABLED().
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: Seth Forshee <seth.forshee@canonical.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/firmware/efivars.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied. Thanks for catching this!
