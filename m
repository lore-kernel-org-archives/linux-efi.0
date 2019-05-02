Return-Path: <SRS0=aRx9=TC=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB40C43219
	for <linux-efi@archiver.kernel.org>; Thu,  2 May 2019 14:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 266DA206DF
	for <linux-efi@archiver.kernel.org>; Thu,  2 May 2019 14:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfEBOCq (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 2 May 2019 10:02:46 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:46318 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEBOCq (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 2 May 2019 10:02:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B9DC374;
        Thu,  2 May 2019 07:02:46 -0700 (PDT)
Received: from [10.163.1.85] (unknown [10.163.1.85])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 600E63F220;
        Thu,  2 May 2019 07:02:37 -0700 (PDT)
Subject: Re: [PATCH] mm/pgtable: Drop pgtable_t variable from pte_fn_t
 functions
To:     Matthew Wilcox <willy@infradead.org>
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Michal Hocko <mhocko@suse.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>, jglisse@redhat.com,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        schwidefsky@de.ibm.com
References: <1556803126-26596-1-git-send-email-anshuman.khandual@arm.com>
 <20190502134623.GA18948@bombadil.infradead.org>
From:   Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <03be69c4-9a63-041c-49fc-249b2bf1d58a@arm.com>
Date:   Thu, 2 May 2019 19:32:42 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190502134623.GA18948@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190502140242.pbx19xTcPmjZSGrwVbZ1Khd9HLVqd8wNCSRhrxaX_fA@z>



On 05/02/2019 07:16 PM, Matthew Wilcox wrote:
> On Thu, May 02, 2019 at 06:48:46PM +0530, Anshuman Khandual wrote:
>> Drop the pgtable_t variable from all implementation for pte_fn_t as none of
>> them use it. apply_to_pte_range() should stop computing it as well. Should
>> help us save some cycles.
> You didn't add Martin Schwidefsky for some reason.  He introduced

scripts/get_maintainer.pl did not list the email but anyways I should have
added it from git blame. Thanks for adding his email to the thread.
 
