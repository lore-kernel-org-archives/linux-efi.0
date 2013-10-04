From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Remove redundant and incorrect memset()
Date: Fri, 04 Oct 2013 10:38:07 -0700
Message-ID: <524EFCFF.3000003@zytor.com>
References: <20131003131054.GB27835@gmail.com> <1380902566-30867-1-git-send-email-roy.franz@linaro.org> <20131004173310.GA15689@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131004173310.GA15689@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Roy Franz <roy.franz@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, matt.fleming@intel.com, msalter@redhat.com, patches@linaro.org
List-Id: linux-efi@vger.kernel.org

On 10/04/2013 10:33 AM, Ingo Molnar wrote:
> 
> * Roy Franz <roy.franz@linaro.org> wrote:
> 
>> Remove a redundant memset() call from efi_relocate_kernel() that
>> was clearing memory that would be used by BSS in non-compressed
>> images loaded with this function.  This clear was redundant with
>> the clearing done in the image itself, and also implemented incorrectly
>> with a 0 length.
>>
>> Signed-off-by: Roy Franz <roy.franz@linaro.org>
>> Acked-by: Mark Salter <msalter@redhat.com>
> 
> Note the title:
> 
>    [PATCH] Remove redundant and incorrect memset()
> 
> if it's both redundant *and* incorrect then the other memset() must be 
> incorrect too and must be removed as well ;-)
> 
> I suspect you wanted the title to say:
> 
>    [PATCH] Remove redundant memset()
> 

And more importantly:

[PATCH] boot,efi: Remove redundant memset()
