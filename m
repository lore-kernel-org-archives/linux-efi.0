From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v2] efi-pstore: Make efi-pstore return a unique id
Date: Wed, 27 Nov 2013 11:44:40 +0000
Message-ID: <20131127114440.GF18170@console-pimps.org>
References: <87bo1bnxhi.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87bo1bnxhi.fsf@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Madper Xie <cxie@redhat.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>, "richard@nod.at" <richard@nod.at>, Tony Luck <tony.luck@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Sat, 23 Nov, at 07:55:37PM, Madper Xie wrote:
> 
> Pstore fs expects that backends provide a uniqued id which could avoid
> pstore making entries as duplication or denominating entries the same
> name. So I combine the timestamp, part and count into id.
> 
> Signed-off-by: Madper Xie <cxie@redhat.com>
> ---
>  drivers/firmware/efi/efi-pstore.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)

Thanks unless anyone complains, I'm going to apply this.

Does this need to be tagged for stable?

-- 
Matt Fleming, Intel Open Source Technology Center
