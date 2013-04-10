From: Lingzhu Xiang <lxiang@redhat.com>
Subject: Re: [PATCH 3/3] efi: Distinguish between "remaining space" and actually
 used space
Date: Wed, 10 Apr 2013 14:02:52 +0800
Message-ID: <5165008C.1000504@redhat.com>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com> <1365561717-12343-3-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1365561717-12343-3-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: matt.fleming@intel.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

On 04/10/2013 10:41 AM, Matthew Garrett wrote:
> +	if (!storage_size || size > remaining_size ||
> +	    ((active_size + size + VAR_METADATA_SIZE > storage_size / 2) &&
> +	     (remaining_size - size - VAR_METADATA_SIZE < storage_size / 2)))

This could overflow.

(u64)32768 - (u64)32768 - VAR_METADATA_SIZE < (u64)65536 / 2 == false
