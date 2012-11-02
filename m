From: Matthew Garrett <mjg@redhat.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Fri, 2 Nov 2012 15:42:48 +0000
Message-ID: <20121102154248.GA7681@srcf.ucam.org>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
 <20121029174131.GC7580@srcf.ucam.org>
 <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
 <20121031150201.GA12394@srcf.ucam.org>
 <20121102153047.GF3300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121102153047.GF3300@redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 02, 2012 at 11:30:48AM -0400, Vivek Goyal wrote:

> "crash" utility has module which allows reading kernel memory. So leaking
> this private key will be easier then you are thinking it to be.

That's not upstream, right?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
