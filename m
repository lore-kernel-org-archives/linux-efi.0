From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v2 1/3] firmware loader: Introduce new API -
 request_firmware_abort()
Date: Mon, 17 Nov 2014 15:12:11 +0000
Message-ID: <20141117151211.GB6810@console-pimps.org>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-2-git-send-email-hock.leong.kweh@intel.com>
 <20141108190655.GA2638@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8529E3@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B8529E3@PGSMSX102.gar.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ming Lei <ming.lei@canonical.com>, "Fleming, Matt" <matt.fleming@intel.com>, Sam Protsenko <semen.protsenko@linaro.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 13 Nov, at 02:51:28AM, Kweh, Hock Leong wrote:
> 
> Hi everyone,
> 
> First of all, I would like to apologize if my commit message gives you guys an impression
> that to use request_firmware_abort(), you guys MUST do the synchronization on your own. 
> But the fact is, it is not a MUST. Below will provide more detail.
> 
> Regarding this synchronization topic, I would like to open a discussion to get a
> better approach to handle this problem. Before jumping onto the design, I would
> like to give a background of why I am doing in this way.
> 
> - Only doing module unload is required to be aware of this synchronization
> 	-> Ensuring the call back does not fall into unloaded code which may cause
> 	     undefined behavior.
> 	-> Ensuring the put_device() & module_put() code have finished in firmware_class.c
> 	     function request_firmware_work_func() before the device is unregistered
> 	     and module unloaded happen.

Shouldn't the existing module_{put,get}() and {put,get}_device() calls
provide all the necessary synchronisation?

Module unload should not be possible while other code is using the
module (and the module refcnt has been incremented accordindly).

Right?

-- 
Matt Fleming, Intel Open Source Technology Center
