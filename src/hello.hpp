#pragma once

#include <string>
#include <string_view>

#include <handlers/hello_client.usrv.pb.hpp>
#include <handlers/hello_service.usrv.pb.hpp>
#include <userver/components/component_list.hpp>
#include <userver/storages/postgres/component.hpp>
#include "hello_client.hpp"

namespace game {

enum class UserType { kFirstTime, kKnown };
std::string SayHelloTo(std::string_view name, UserType type);

class Hello final : public handlers::api::HelloServiceBase::Component {
public:
    static constexpr std::string_view kName = "handler-hello";

    Hello(const userver::components::ComponentConfig& config,
          const userver::components::ComponentContext& component_context)
        : handlers::api::HelloServiceBase::Component(config, component_context)
        , PgCluster_(
                component_context
                    .FindComponent<userver::components::Postgres>("postgres-db-1")
                    .GetCluster())
        , Client_(component_context.FindComponent<HelloClient>())
        {
        }

    SayHelloResult SayHello(CallContext& context,
                            handlers::api::HelloRequest&& request);

private:
    userver::storages::postgres::ClusterPtr PgCluster_;
    HelloClient& Client_;
};

void AppendHello(userver::components::ComponentList& component_list);

}  // namespace game
