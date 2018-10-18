From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v9 2/8] x86/boot: Copy kstrtoull() to compressed period
Date: Thu, 18 Oct 2018 12:03:38 +0800
Message-ID: <20181018040338.GC1885@192.168.1.4>
References: <20181017102012.872-1-fanc.fnst@cn.fujitsu.com>
 <20181017102012.872-3-fanc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181017102012.872-3-fanc.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Fan <fanc.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, msys.mizuma@gmail.com, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On 10/17/18 at 06:20pm, Chao Fan wrote:
> Copy kstrtoull() to 'compressed' directory so that
> we can use it to change the address in cmdline from
> string to unsigned long long.

So you don't like simple_strtoull() in arch/x86/boot/string.c which has
been used in boot/compressed/kaslr.c . Why? Are you going to clean up
simple_strtoull()?
