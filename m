From: Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH V4 1/3] efi: Determine how much space is used by boot
 services-only variables
Date: Fri, 12 Apr 2013 11:22:49 +0100
Message-ID: <5167E079.5060900@intel.com>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com> <1365615967-27346-1-git-send-email-matthew.garrett@nebula.com> <5167DEE9.6050006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5167DEE9.6050006@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lingzhu Xiang <lxiang@redhat.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 12/04/13 11:16, Lingzhu Xiang wrote:
> On 04/11/2013 01:46 AM, Matthew Garrett wrote:
>>       ops.query_variable_store = efi_query_variable_store;
> 
> Can't apply here. ops.query_variable_info = efi.query_variable_info?

It's against the 'urgent' branch at,

    git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
